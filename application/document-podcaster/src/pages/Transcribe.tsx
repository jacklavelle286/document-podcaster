import { faTruckMedical } from "@fortawesome/free-solid-svg-icons";
import Button from "../components/Buttons";
import Card from "../components/Card";
import TranscribeModal from "../components/TranscribeModal";

export default function Transcribe() {
  const successfullSubmit = false;
  const error = "Error";
  return (
    <>
      <TranscribeModal></TranscribeModal>
      <Card
        backgroundColour={
          successfullSubmit ? "var(--bs-green)" : "var(--bs-red)"
        }
        hoverEffect={false}
        cardTextColour="white"
      >
        <div className="">
          <h1 className="text-white justify text-center">
            Transcription {successfullSubmit ? "Success" : "Failure"}
          </h1>
          <p className="text-white justify text-center">
            {successfullSubmit
              ? "Download your transcription below:"
              : `Error transcribing document, see error below: ${error}`}
          </p>
          {successfullSubmit ? (
            <Button
              buttonColour="success"
              buttonTextColour="white"
              buttonText="Download Transcript"
            ></Button>
          ) : (
            <Button
              buttonColour="danger"
              buttonTextColour="white"
              buttonText="Try Again"
            ></Button>
          )}
        </div>
      </Card>
    </>
  );
}
