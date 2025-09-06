import { useState } from "react";
import Button from "./Buttons";
import useVoices from "./useVoices";

type Status = "idle" | "loading" | "success" | "error";

export default function TranscribeForm() {
  const { voices, loading: voicesLoading, error: voicesError } = useVoices();
  const API_BASE = import.meta.env.VITE_API_BASE_URL as string;
  const [voiceType, setVoiceType] = useState<string>("");
  const [file, setFile] = useState<File | null>(null);

  const [status, setStatus] = useState<Status>("idle");
  const [error, setError] = useState<string | null>(null);
  const [result, setResult] = useState<{ url: string } | null>(null);

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setStatus("loading");
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

      const bodyJson = await res.json();
      setResult(bodyJson);

      const { url, objectKey } = bodyJson;

      const putRes = await fetch(url, {
        method: "PUT",
        headers: { "content-type": file?.type || "application/octet-stream" },
        body: file,
      });

      if (!putRes.ok) throw new Error(`Upload Failed: ${putRes.status}`);

      setStatus("success");
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      setError(msg);
      setStatus("error");
      setError(null);
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
          <option value="">Choose a Voice</option>
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
      <div className="d-flex justify-content-center">
        <Button
          buttonType="submit"
          buttonColour="primary"
          buttonText="Transcribe"
        ></Button>
      </div>
      {status === "loading" && (
        <div className="d-flex justify-content-center primary p-3">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Loading...</span>
          </div>
        </div>
      )}
      {status === "success" && result && (
        <div className="d-flex justify-content-center">
          <p className="m-4">Uploaded {file?.name}</p>
        </div>
      )}
      {status === "error" && (
        <div className="d-flex justify-content-center p-2">
          <p className="mt-3 text-danger">Error: {error}</p>
        </div>
      )}
    </form>
  );
}
