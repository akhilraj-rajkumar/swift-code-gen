# SwiftCodeGen

A command line utility to generate model and web service classes in Swift programming language. This is a simple and lightweight tool for developers to automate a part of effort. The tool will generate all the required model classes and web service classes with a single command.

### Installation

SwiftGen is written in Python, and it requires python 2.7 or above to work.

Install SwiftGen and use simple commands.

```sh
$ pip install SwiftGen
```

If you have already a version installed...

```sh
$ pip install SwiftGen --update
```

### Usage

SwiftGen uses `SwiftGenConf.json` file to keep api details and other common properties to configure basic setups. It also uses template files to generate model and service classes. A sample configuration file can be found [here](https://github.com/akhilraj-rajkumar/swift-code-gen#swiftgenconfjson).

To initialise setup...
```sh
$ cd project/location
$ swiftcodegen init
```

The `init` command will setup the required basic setup in the project directory. The command will create a `SwiftGen/` folder and adds required config and template files. The folder structure will be as below
```
/project/location/
|--.git/
|   |--git configuration files
|--.gitignore
|--MyProject/
|  |--ViewControllers
|  |--Models etc.
|--MyProject.xcodeproj
|--MyProject.xcworkspace
|--podfile
|--Pods/
|  |-- pod files
|--README.md
|--SwiftGen/
|  |--SwiftGenConf.json
|  |--ModelTemplate.swift
|  |--ServiceTemplate.swift
|  |--TypeMap.json
```
Basic values will be filled in the configuration file which can be edited to add required details. Read more on config file customisations [here](https://github.com/akhilraj-rajkumar/swift-code-gen#customization).

After initialisation, the configuration and setup can be validated by...
```sh
$ swiftcdoegen validate
```
The `validate` command will check the required values in configuration file and validate them. Appropriate error messages will be logged to resolve the error if exist.

To generate model and service classess as updated in configuration file (`SwiftGenConf.json`)...

```sh
$ swiftcodegen gen
```
The `gen` command will generate the model classes and service classes as specified in the configuration file.

### Customization
The config and template files in `/SwiftGen` folder are customizable.

###### SwiftGenconf.json
A sample config file will look like,
```
{
	"project_path": "",
	"apis": [{
		"api_name": "GetUser",
		"endpoint": "some/path/getUser",
		"request": "",
		"method": "GET",
		"response": {
			"first_name": "Akhilraj",
			"last_name": "Rajkumar",
			"age": "30",
			"sex": "M"
		}
	}],
	"project_name": "MyProject",
	"class_prefix": "",
	"base_directory": "MyProject"
}
```

Availbe keys and expected values are,
Note: Possible values will be prefilled on `init`, if the command is used from project directory. All paths are relative to location of config file.

| Name | Value |
| ------ | ------ |
| project_name | Name of the project, value will be prefilled on `init`. |
| project_path | Directory path of `.xcodeproj` file. |
| base_directory | Directory where generated model and service classes to be added. |
| class_prefix | Classname prefix. |
| apis | An array of api's. |

##### `apis` customization 
In `SwiftGenConf.json` file, an array/list of values is expected for `apis` key. Each item in api list will have the following key-value pairs.

| Name | Value |
| ------ | ------ |
| api_name | A name for api, this is used to name the request and response classes. |
| endpoint | api endpoint url. |
| method | Request method like GET, POST etc. |
| request | Request json or empty if nothing. It could be `[]` or `{}`. |
| response | Response json, it could be `[]` or `{}`.
| model_alias | Alias name for models. Expects key-value pairs `{}`. |

##### `endpoint` example:
Value of endpoint is expected to be a string, with or without host part. SwiftCodeGen will only take the path par from the url. Two types of url strings are supported now,
   - "endpoint" : "some/path/getUser"
   - "endpoint" : "some/path/Users/{userId}"
 
In the second example, userId will be added as method parameter and value will be substituted.
 
##### `model_alias` example:
Value of model_alias is expected to be key-value pairs. This is used to map a model or a part in request/response to another model.

```
{
	"project_path": "",
	"apis": [{
		"api_name": "GetUser",
		"endpoint": "some/path/getUser",
		"request": "",
		"method": "GET",
		"response": {
			"first_name": "Akhilraj",
			"last_name": "Rajkumar",
			"age": "30",
			"sex": "M"
		}
	}],
	"project_name": "MyProject",
	"class_prefix": "",
	"base_directory": "MyProject"
}
```
In the above configuration, the `GetUser` api response will be mapped to a model named `GetUserResponse`. If the model need to be another name, like `User`, add model_alias in that api json. eg:

```
{
	"project_path": "..",
	"apis": [{
		"api_name": "UpdateSomething",
		"endpoint": "some/path/updateSome",
		"request": {
		    "key" : "value"
		},
		"method": "POST",
		"response": {
			"status_code": 0,
			"message": "Success/Fail message"
		},
		"model_alias": {
			"response": "User"
		}
	}],
	"project_name": "MyProject",
	"class_prefix": "",
	"base_directory": "../MyProject"
}
```

Here the response of `GetUser` is mapped to `User`, so the model name will be `User`.


Another example, consider
```
{
	"project_path": "..",
	"apis": [{
		"api_name": "UpdateSomethingOne",
		"endpoint": "some/path/updateSomethingOne",
		"request": {
		    "key" : "value"
		},
		"method": "POST",
		"response": {
			"status_code": 0,
			"message": "Success/Fail message"
		},
		"model_alias": {
		    "request" : "UpdateRequest",
			"response": "CommonResponse"
		}
	}, {
		"api_name": "UpdateSomethingTwo",
		"endpoint": "some/path/updateSomeTwo",
		"request": {
		    "key" : "value"
		},
		"method": "POST",
		"response": {
			"status_code": 0,
			"message": "Success/Fail message"
		},
		"model_alias": {
		    "request" : "UpdateRequest",
			"response": "CommonResponse"
		}
	}],
	"project_name": "MyProject",
	"class_prefix": "",
	"base_directory": "../MyProject"
}
```
In the above sample, both update requests have same kind of request and response, since each one is provided with aliases, no seperate model's will be generated for two request. Same `UpdateRequest` model and `CommonResponse` model will be used. If the aliases are not provided, both api will generate seperate request and response models. So the providing alias can avoid different models with same properties.

Apart from the whole request or response, any part of json can be aliased. eg:
```
{
  "project_path": "..",
  "apis": [
    {
      "api_name": "GetUser",
      "endpoint": "some/path/getUser",
      "request": "",
      "method": "GET",
      "response": {
        "first_name": "Akhilraj",
        "last_name": "Rajkumar",
        "age": "30",
        "sex": "M"
      },
      "model_alias": {
        "response": "User"
      }
    },
    {
      "api_name": "GetContacts",
      "endpoint": "some/path/getContacts",
      "request": "",
      "method": "GET",
      "response": {
        "contacts": [
          {
            "first_name": "Akhilraj",
            "last_name": "Rajkumar",
            "age": "30",
            "sex": "M"
          }
        ]
      },
      "model_alias": {
        "contacts": "User"
      }
    }
  ],
  "project_name": "MyProject",
  "class_prefix": "",
  "base_directory": "../MyProject"
}
```
In the above example a part of response is aliased to User model. So in GetContacts response array of User model will be used.

#### Template Classes
SwiftCodeGen uses two template classes, `ModelTemplate.swift` and `ServiceTemplate.swift`. Model template uses `ObjectMapper` to map json to model. So the application require [`ObjectMapper`](https://github.com/Hearst-DD/ObjectMapper) module. Service classes are generated from ServiceTemplate which is created based on [`Alamofire`](https://github.com/Alamofire/Alamofire). The service template class is customizible as per project and imlpementation. A sample service template file will look like,
```swift
import Foundation
import ObjectMapper

class $class_name : BaseWebService {

    typealias successCallback = ($response_type?) -> Void
    typealias failureCallback = (Error) -> Void

    var success:successCallback?
    var failure:failureCallback?

    func $method_name($request_var onSuccess:@escaping successCallback, onFailure:@escaping failureCallback) {

        self.success = onSuccess
        self.failure = onFailure
        self.urlString = "$endpoint"
        self.requestMethod = $request_type
        self.parameters = $request_params
        self.startWebService(success: { JSON in

            let response = Mapper<$response_model>().$map_type
            self.success?(response)
            }) { error in

                self.failure?(error!)
        }
    }
}
```
This template class is created as a subclass of `BaseWebService` class. The base service class used in the example can be found [here](https://github.com/akhilraj-rajkumar/swift-code-gen/blob/master/SwiftGen/BaseWebService.swift). In the template class, values starts with `$` will be substituted with actual values generated from `SwiftGenConf.json` file. Available options are,

| Name | Value |
| ----- | ----- |
| $response_type | This will be a model or array of model as per `response` specified in conf file. |
| $method_name | A name for method, formed from `name` value in conf file. |
| $request_var | This will be a model or array of model as per `request` specified in conf file. It will be empty if nothing provided in `request`. |
| $endpoint | Endpoint url created from `endpoint` value in conf file. |
| $request_type | Type of request like GET, POST etc configured from `method` value from conf file. |
| $request_params | A `[String : Any]` variable created from request model using ObjectMapper. Value will be `nil` if nothing is provided in `request`. |
| $response_model | Model name of response. |
| $map_type | Mapping to object or oject array. |

The above values will be filled to create service classes. The template file can be configured to any form and SwiftCodeGen will format and fill the above variables present in the template file. So depends on project template file can be custmized providing the above variables.

### Todos

 - Support GET request with URL parameters.
 - Possible customizations.

License
----
Apache License

### Author
Akhilraj Rajkumar - https://github.com/akhilraj-rajkumar