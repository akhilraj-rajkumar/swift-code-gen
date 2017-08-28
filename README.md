# SwiftGen

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

SwiftGen uses `SwiftGenConf.json` file to keep api details and other common properties to configure basic setups. A sample configuration file can be found [here]().

To validate the configuration file...
```sh
$ swiftgen validate
```
The `validate` command will check the required values in configuration file and validate them. Appropriate error messages will be logged to resolve the error if exist.

To generate model and service classess...

```sh
$ swiftgen gen
```
The `gen` command will generate the model classes and service classes as specified in the configuration file.
