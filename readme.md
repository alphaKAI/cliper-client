#Cliper-Client
`Cliper` is an online clipboard sync tool.  
`Cliper-Client` is a component of Cliper composed of `clipcpy` and `clippst`.  
You can use global clipboard like `pbcopy` and `pbpaste`.(But cliper doesn't access to your local clipboard)  

##Requirements

- DMD v2.071.2 or later
- DUB 1.0.0 or later

##Installation

```zsh
$ git clone https://github.com/alphaKAI/cliper-client
$ cd cliper-client
$ cd clipcpy
$ dub build
$ cd ../
$ cd clippst
$ dub build
```

##Configuration
`Cliper-Client` can be configured with environment variable.  
You must set required values before use.  

|VALUE|Description|
|-----|-----------|
|CLIPER\_SERVER\_ADDRESS|Address to `Cliper-Server`. (This value is required)|
|CLIPER\_APIKEY|APIKEY of `Cliper-Server`. (This value is required)|

##Usage
###Setup: Acquirering the APIKEY
You must acquire the APIKEY at first, `Cliper-Server` requires the key to identify the user and for authorizing.  
(In this explanation, `CLIPER\_SERVER\_ADDRESS` is set as `https://example.com`.)  
You can obtain the key with single HTTP request to the `Cliper-Server`.  
All you have to do is execute the command:  

```zsh
$ curl -X POST $CLIPER_SERVER_ADDRESS/api/v1/users
{"apikey":"3f483b26-c83e-4d4e-93e6-6bf6d96063a8","status":0}
$ #↑this is an apikey for you!
```
then, you have to set the value into `CLPER_APIKEY`.  
`export CLIPER_APIKEY="3f483b26-c83e-4d4e-93e6-6bf6d96063a8"`

Though I forgot to tell you, you have to add paths of `clipcpy` and `clippst` into your `$PATH` before using.  

###Copying
```
$ echo foo | clipcpy
```

You can copy binary file as follows:  

```
$ cat foo.png | clipcpy
```

###Pasting
```
$ clippst
```

##License
Copyright (c) 2017, Akihiro Shoji  
`Cliper-Client` is released under the MIT License.  
Please see `LICENSE` for details.  

