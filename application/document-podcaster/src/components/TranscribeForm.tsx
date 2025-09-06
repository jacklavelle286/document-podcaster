import { useState } from "react";
import Button from "./Buttons";


// first, send metadata to lambda:

// 
// {
//   "fileName": "my-audio.mp3",
//   "fileType": "audio/mpeg",
//   "voiceType": "Voice A"
// }


type Status = "idle" | "loading" | "success" | "error";

export default function TranscribeForm() {
  const voices = ["Voice A", "Voice B", "Voice C"];
  const API_BASE = import.meta.env.VITE_API_BASE_URL as string;
  const [voiceType, setVoiceType] = useState<string>("");
  const [file, setFile] = useState<File | null>(null);

  const [status, setStatus] = useState<Status>("idle");
  const [error, setError] = useState<string | null>(null);
  const [result, setResult] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setStatus("loading");
    setFile(null);
    setError(null);
    setResult(null);

    try {
      const payload = {
        voiceType,
        fileName: file?.name ?? null,
      };

      const res = await fetch(`${API_BASE}/uploads`, {
        method: "POST",
        headers: { "Content-type": "application/json" },
        body: JSON.stringify(payload),
      });

      if (!res.ok) throw new Error(`HTTP ${res.status} ${res.statusText}`);

      const bodyText = await res.text();
      setResult(bodyText);
      setStatus("success");
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      setError(msg);
      setStatus("error");
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      <div className="mb-3">
        <label htmlFor="voice-type" className="form-label">
          Voice Type
        </label>
        <select
          className="form-select"
          id="voice-type"
          value={voiceType}
          onChange={(e) => setVoiceType(e.target.value)}
          required
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
        <input
          className="form-control"
          type="file"
          id="formFile"
          onChange={(e) => {
            const target = e.target as HTMLInputElement;
            setFile(target.files && target.files[0] ? target.files[0] : null);
          }}
        />
      </div>
      <div style={{ display: "flex", justifyContent: "center" }}>
        <Button
          buttonType="submit"
          buttonColour="primary"
          buttonText="Transcribe"
        ></Button>
      </div>
      {status === "success" && <p className="mt-3">Response: {result}</p>}
      {status === "error" && <p className="mt-3 text-danger">Error: {error}</p>}
    </form>
  );
}
