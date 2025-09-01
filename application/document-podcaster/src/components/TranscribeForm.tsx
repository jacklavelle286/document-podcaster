import Button from "./Buttons";

export default function TranscribeForm() {
  const voices = ["Voice A", "Voice B", "Voice C"];
  const submitted = false;
  return (
    <form>
      <div className="mb-3">
        <label htmlFor="voice-type" className="form-label">
          Voice Type
        </label>
        <select
          className="form-select"
          id="voice-type"
          aria-label="Default select example"
        >
          <option value="" selected>
            Choose a Voice
          </option>
          {voices.map((voice, idx) => (
            <option key={idx} value={voice}>
              {voice}
            </option>
          ))}
        </select>
        <div id="emailHelp" className="form-text">
          Select which voice you'd like your transcription to be read in.
        </div>
      </div>
      <div className="mb-3">
        <label htmlFor="formFile" className="form-label">
          Default file input example
        </label>
        <input className="form-control" type="file" id="formFile" />
      </div>
    <div style={{ display: "flex", justifyContent: "center" }}>
      <Button
        buttonType="submit"
        buttonColour="primary"
        buttonText="Transcribe"
      ></Button>
    </div>
    </form>
  );
}
