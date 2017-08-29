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

SwiftGen uses `SwiftGenConf.json` file to keep api details and other common properties to configure basic setups. It also uses template files to generate model and service classes. A sample configuration file can be found [here](https://github.com/akhilraj-rajkumar/swift-code-gen/blob/master/SwiftGen/SwiftGenConf.json).

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
Basic values will be filled in the configuration file which can be edited to add required details. Read more on config file customisations [here]().

After initialisation, the configuration and setup can be validated by...
```sh
$ swiftcdoegen validate
```
The `validate` command will check the required values in configuration file and validate them. Appropriate error messages will be logged to resolve the error if exist.

To generate model and service classess as updated in configuration file (`SwiftGenConf.json`)...

```sh
$ swiftgen gen
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

###### `apis` customization 
In `SwiftGenConf.json` file, an array/list of values is expected for `apis` key. Each item in api list will have the following key-value pairs.

| Name | Value |
| ------ | ------ |
| api_name | A name for api, this is used to name the request and response classes. |
| endpoint | api endpoint url. |
| method | Request method like GET, POST etc. |
| request | Request json or empty if nothing. It could be `[]` or `{}`. |
| response | Response json, it could be `[]` or `{}`.
| model_alias | Alias name for models. Expects key-value pairs `{}`. |

`endpoint` example:
Value of endpoint is expected to be a string, with or without host part. SwiftCodeGen will only take the path par from the url. Two types of url strings are supported now,
   - "endpoint" : "some/path/getUser"
   - "endpoint" : "some/path/Users/{userId}"
 
In the second example, userId will be added as method parameter and value will be substituted.
 
`model_alias` example:
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
In the above sample, both update requests have same kind of request and response, since each one is provided with aliases, no seperate model's will be generated for two request. Same `UpdateRequest` model and `CommonResponse` model will be used. If the aliases are not provided, both api will generate seperate request and response models. So the alias can avoid different models with same properties.