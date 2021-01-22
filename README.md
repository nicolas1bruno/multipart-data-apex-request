# multipart/form-data request

#### Sampe
```
String fileName = 'file.png';
String fileContent = ''; //base64 encoded

Blob formData = HttpHexFormBuilder.build()
        .writeParam( 'id', '123' )
        .writeParam( 'message', 'my second paramter' )
        .writeFile( 'file', fileName, fileContent )
        .getFormAsBlob();

HttpRequest request = new HttpRequest();
request.setEndpoint(endpoint);
request.setHeader( 'Connection', 'keep-alive' );
request.setHeader( 'Content-Length', String.valueOf(formData.size()) );
request.setHeader( 'Content-Type', HttpHexFormBuilder.GetContentType() );
request.setBodyAsBlob(formData);

Http http = new Http();        
HttpResponse respose = http.send(request);
```