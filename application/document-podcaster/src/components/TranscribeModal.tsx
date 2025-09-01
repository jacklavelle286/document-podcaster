import Button from "./Buttons";
import TranscribeForm from "./TranscribeForm";

export default function TranscribeModal() {
  return (
    <>
      <h1 className="text-center p-5">Upload Your Document</h1>
      <div className="d-flex justify-content-center">
        <Button
          buttonText="Upload Document"
          buttonColour="primary"
          buttonType="button"
          dataBSToggle="modal"
          dataBSTarget="#exampleModal"
          buttonTextColour="white"
        />
      </div>
      <div
        className="modal fade"
        id="exampleModal"
        tabIndex={-1}
        aria-labelledby="exampleModalLabel"
        aria-hidden="true"
      >
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <h1
                className="modal-title fs-5 d-flex justify-content-center w-100"
                id="exampleModalLabel"
              >
                Transcribe Your Document
              </h1>
              <Button
                buttonType="button"
                buttonColour="close"
                buttonText=""
                dataBSDismiss="modal"
              ></Button>
            </div>
            <div className="modal-body">
              <TranscribeForm></TranscribeForm>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
