# document-podcaster
This app turns documents into downloadable mp3 files.



    # to do:

    - Ensure this works with DOCX and PDFs
    - Plug in name from frontend
    - Create polling Lambda and front end
    - Edit transcriber to read DynamoDB with jobId
    - Fix React to either download MP3 or throw error on page
    - Robust error handling in functions
    - Dark mode
    - Refresh voices button


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
