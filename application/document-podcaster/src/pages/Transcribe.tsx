import Card from "../components/Card";
import TranscribeModal from "../components/TranscribeModal";

export default function Transcribe() {
  const successfullSubmit = true;
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
              : "Error transcribing document: "}
          </p>
        </div>
      </Card>
    </>
  );
}
