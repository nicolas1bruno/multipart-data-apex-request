public class HttpHexFormBuilder {
    private final static string BOUNDARY = '----sfdc-multi-form';
    private String form ;
 
    public HttpHexFormBuilder() {
        form = '';
    }
 
    public static HttpHexFormBuilder build(){
        return new HttpHexFormBuilder();
    }
 
    public static String getBoundary() {
        return BOUNDARY;
    }
 
    public static string GetContentType() {
        return 'multipart/form-data; boundary="' + BOUNDARY + '"';
    }
 
    private HttpHexFormBuilder writeFooter(){
        this.form += EncodingUtil.convertToHex( Blob.valueOf( '--' + boundary + '--' ) );
        return this;
    }
    
    public HttpHexFormBuilder writeParam( String key, String value ) {
        String body = '--' + BOUNDARY;
        body += '\r\nContent-Disposition: form-data; name="' + key + '";\r\n\r\n' + value + '\r\n';
        
        this.form += EncodingUtil.convertToHex( Blob.valueOf( body ) );
        return this;
    }
    
    public HttpHexFormBuilder writeFile( String key, String fileName, String fileContent ){
        String mimeType = resolveMimeType(fileName);
 
        String content = '--' + BOUNDARY;
        content += '\r\nContent-Disposition: form-data; name="' + key + '"; filename="' + fileName + '";\r\nContent-Type: ' + mimeType + ';\r\n\r\n';
        content = EncodingUtil.convertToHex( Blob.valueOf( content ) );
 
        content += EncodingUtil.convertToHex( EncodingUtil.base64Decode( fileContent ) );
        content += EncodingUtil.convertToHex( Blob.valueOf( '\r\n' ) );
 
        this.form += content;
        return this;
    }
 
    public String getFormAsString() {
        this.writeFooter();
        return this.form;
    }
    
    public Blob getFormAsBlob() {
        return EncodingUtil.convertFromHex( this.getFormAsString() );
    }
 
    private static String resolveMimeType(String fileName) {
        String fileType = fileName.substringAfterLast('.');
        String mimeType = 'image/png';
        if (fileType.equalsIgnoreCase('png')) {
            mimeType = 'image/png';
        } else if (fileType.equalsIgnoreCase('jpeg') || fileType.equalsIgnoreCase('jpg')) {
            mimeType = 'image/jpg';
        } else if (fileType.equalsIgnoreCase('pgm')) {
            mimeType = 'image/x-portable-graymap';
        } else if (fileType.equalsIgnoreCase('ppm')) {
            mimeType = 'image/x-portable-pixmap';            
        } else if (fileType.equalsIgnoreCase('pdf')) {
            mimeType = 'application/pdf';            
        }
        return mimeType;
    }
}