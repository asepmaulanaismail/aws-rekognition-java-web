<%@ page import = "java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import = "javax.servlet.http.*" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "org.apache.commons.io.output.*" %>
<%@ page import = "com.amazonaws.services.rekognition.AmazonRekognition" %>
<%@ page import = "com.amazonaws.services.rekognition.AmazonRekognitionClientBuilder" %>
<%@ page import = "com.amazonaws.AmazonClientException" %>
<%@ page import = "com.amazonaws.auth.AWSCredentials" %>
<%@ page import = "com.amazonaws.auth.AWSStaticCredentialsProvider" %>
<%@ page import = "com.amazonaws.auth.profile.ProfileCredentialsProvider" %>
<%@ page import = "com.amazonaws.regions.Regions" %>
<%@ page import = "com.amazonaws.services.rekognition.model.AmazonRekognitionException" %>
<%@ page import = "com.amazonaws.services.rekognition.model.DetectLabelsRequest" %>
<%@ page import = "com.amazonaws.services.rekognition.model.DetectLabelsResult" %>
<%@ page import = "com.amazonaws.services.rekognition.model.Image" %>
<%@ page import = "com.amazonaws.services.rekognition.model.Label" %>
<%@ page import = "com.amazonaws.services.rekognition.model.S3Object" %>
<%@ page import = "com.amazonaws.services.s3.AmazonS3" %>
<%@ page import = "com.amazonaws.services.s3.AmazonS3ClientBuilder" %>
<%@ page import = "com.amazonaws.services.s3.model.ObjectMetadata" %>
<%@ page import = "com.amazonaws.services.s3.model.PutObjectRequest" %>
<%@ page import = "com.amazonaws.AmazonServiceException" %>
<%@ page import = "com.amazonaws.SdkClientException" %>

<%
   File file ;
   int maxFileSize = 5000 * 1024;
   int maxMemSize = 5000 * 1024;
   ServletContext context = pageContext.getServletContext();
   String webInfPath = getServletConfig().getServletContext().getRealPath("pages");
   String filePath = webInfPath + "/uploads/";

   // Verify the content type
   String contentType = request.getContentType();
   
   if ((contentType.indexOf("multipart/form-data") >= 0)) {
      DiskFileItemFactory factory = new DiskFileItemFactory();
      // maximum size that will be stored in memory
      factory.setSizeThreshold(maxMemSize);
      
      // Location to save data that is larger than maxMemSize.
      factory.setRepository(new File("c:\\temp"));

      // Create a new file upload handler
      ServletFileUpload upload = new ServletFileUpload(factory);
      
      // maximum file size to be uploaded.
      upload.setSizeMax( maxFileSize );
      
      try { 
         // Parse the request to get file items.
         List fileItems = upload.parseRequest(request);

         // Process the uploaded file items
         Iterator i = fileItems.iterator();

         out.println("<html>");
         out.println("<head>");
         out.println("<title>JSP File upload</title>");  
         out.println("<link href='https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB' crossorigin='anonymous'>"); 
         out.println("</head>");
         out.println("<body class='container' style='margin-top: 100px;'>");
         out.println("<nav class='navbar navbar-expand-lg navbar-dark bg-dark fixed-top'>");
        out.println("<div class='container'>");
        out.println("<a class='navbar-brand' href='#'>PBO 6</a>");
        out.println("<button class='navbar-toggler' type='button' data-toggle='collapse' data-target='#navbarResponsive' aria-controls='navbarResponsive' aria-expanded='false' aria-label='Toggle navigation'>");
        out.println("<span class='navbar-toggler-icon'></span>");
        out.println("</button>");
        out.println("</div>");
		 out.println("</nav>");
         out.println("<div class='row' style='margin-bottom: 10px;'>");
         out.println("<div class='col-md-6'>");
         out.println("<a href='/aws-rekognition-java-web' class='btn btn-primary'>Kembali</a>");
         out.println("</div>");
         out.println("</div>");
         out.println("<div class='row'>");
         out.println("<div class='col-md-6'>");
         
         while ( i.hasNext () ) {
            FileItem fi = (FileItem)i.next();
            if ( !fi.isFormField () ) {
               // Get the uploaded file parameters
               String fieldName = fi.getFieldName();
               String fileName = "upload.jpg";
               boolean isInMemory = fi.isInMemory();
               long sizeInBytes = fi.getSize();
            
               // Write the file
               file = new File( filePath + fileName) ;
               fi.write( file ) ;
               
               // Post to AWS
               String photo = fileName;
               String bucket = "rekognition-1506";

				AWSCredentials credentials;
				try {
				    credentials = new ProfileCredentialsProvider("rekognition-user").getCredentials();
				} catch(Exception e) {
				   throw new AmazonClientException("Cannot load the credentials from the credential profiles file. "
				    + "Please make sure that your credentials file is at the correct "
				    + "location (/Users/userid/.aws/credentials), and is in a valid format.", e);
				}
		        String clientRegion = "us-east-1";
		        String bucketName = bucket;
		        String stringObjKeyName = fileName;
		        String fileObjKeyName = fileName;
		        try {
		            AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
		                    .withRegion(clientRegion)
		                    .withCredentials(new ProfileCredentialsProvider())
		                    .build();
		        
		            // Upload a text string as a new object.
		            s3Client.putObject(bucketName, stringObjKeyName, file);
		        }
		        catch(AmazonServiceException e) {
		            // The call was transmitted successfully, but Amazon S3 couldn't process 
		            // it, so it returned an error response.
		            e.printStackTrace();
		        }
		        catch(SdkClientException e) {
		            // Amazon S3 couldn't be contacted for a response, or the client
		            // couldn't parse the response from Amazon S3.
		            e.printStackTrace();
		        }
				AmazonRekognition rekognitionClient = AmazonRekognitionClientBuilder
		    	         .standard()
		    	         .withRegion(Regions.US_EAST_1)
		    	         .withCredentials(new AWSStaticCredentialsProvider(credentials))
		    	         .build();

		      DetectLabelsRequest AWSRequest = new DetectLabelsRequest()
		    		  .withImage(new Image()
		    		  .withS3Object(new S3Object()
		    		  .withName(photo).withBucket(bucket)))
		    		  .withMaxLabels(10)
		    		  .withMinConfidence(30F);

		      try {
		         DetectLabelsResult result = rekognitionClient.detectLabels(AWSRequest);
		         List <Label> labels = result.getLabels();

	             out.println("<img src='/aws-rekognition-java-web/pages/uploads/" + fileName  + "' width='500px'/>");
	             out.println("</div>");
	             out.println("<div class='col-md-6'>");
		         out.println("<h4>Detected labels</h4>");
		         for (Label label: labels) {
		            out.println(label.getName() + ": " + label.getConfidence().toString() + "<br/>");
		         }
	             out.println("</div>");
		      } catch(AmazonRekognitionException e) {
		         e.printStackTrace();
		      }
               // END post to AWS
               
            }
         }
         out.println("</div>");
         out.println("</body>");
         out.println("</html>");
      } catch(Exception ex) {
         System.out.println(ex.getMessage());
      }
   } else {
      out.println("<html>");
      out.println("<head>");
      out.println("<title>Servlet upload</title>");  
      out.println("</head>");
      out.println("<body>");
      out.println("<p>No file uploaded</p>"); 
      out.println("</body>");
      out.println("</html>");
   }
%>