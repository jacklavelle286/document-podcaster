import Card from "../components/Card";

export default function Documentation() {
  return (
    <>
      <h2 className="text-center p-3 m-5">📄 Documentation </h2>
      <Card backgroundColour="var(--bs-light-50)" hoverEffect={false}>
        <h1>Intructions</h1>
        <div style={{ display: "flex", justifyContent: "center" }}>
          <ol
            className=""
            style={{
              width: "75%",
              minWidth: "250px",
              margin: "0 auto",
              textAlign: "left",
            }}
          >
            <li>Navigate to the Transcribe page.</li>
            <li>
              Select Upload Document (we accept docx, PDF and text files
              currently) and upload your document to transcribe.
            </li>
            <li>Select the voice of your choosing and click Transcribe.</li>
            <li>You will then be given a link to your downloadable mp3 file consisting of your transcription!</li>
            <p className="p-3">Note: Should you want to either more information about your transcription or view or delete past transcriptions, view the Transcriptions page.</p>
          </ol>
        </div>
      </Card>
    </>
  );
}

// - Frequently Asked Questions (FAQ) section  
// - Supported file types and size limits  
// - Troubleshooting tips for common issues  
// - Privacy and data handling information  
// - Contact/support details  
// - Feature roadmap or changelog  
// - Accessibility information  
// - Example use cases or sample transcriptions  
// - Links to related resources or tutorials  
// - Keyboard shortcuts or advanced options