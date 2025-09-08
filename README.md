# document-podcaster
This app turns documents into downloadable mp3 files.



    # to do:


1. ensure this works with docx and pdfs
2. plug in name from frontend
3. create polling lambda
4. edit uploader lambda to initialise records in dynamo
5. edit transcriber to read dynamo with jobId
6. Fix react to either download mp3 / throw error on page.
7. Robust error handling in functions 
8. Dark mode 
9. PDF support


# orchestrate:

# React (POST /uploads with options)
#     └── API creates jobId + DynamoDB item (stores voice/language/engine)
#           └── API returns { jobId, uploadUrl, objectKey }
# React PUT file to S3 at objectKey
# S3 event fires transcriber function
#     └── Parse jobId from key -> read DynamoDB -> get options
#     └── Extract text -> Polly (options) -> write outputs/{jobId}.mp3
#     └── Update DynamoDB: { status: SUCCEEDED, outputKey }
# React polls GET /jobs/{jobId}
#     └── If SUCCEEDED -> API generates presigned GET for outputKey -> returns URL
