import { useEffect, useState } from "react";

export type Voice = {
  Id: string;
  Name: string;
  LanguageCode: string;
  LanguageName: string;
  Gender: string;
  SupportedEngines: string[];
};

type VoicesResponse = {voices: Voice[]};

export default function useVoices() {
  const API_BASE = import.meta.env.VITE_API_BASE_URL as string;

  const [voices, setVoices] = useState<Voice[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const ctrl = new AbortController();

    (async () => {
      try {
        setLoading(true);
        const url = `${API_BASE}/get-voices?language=en-GB&engine=standard`;
        const res = await fetch(url, { method: "GET", signal: ctrl.signal });
        console.log("[voices] status", res.status);
        if (!res.ok) throw new Error(`HTTP ${res.status}: ${res.statusText}`);

        const data: VoicesResponse = await res.json();
        console.log("[voices] payload", data);

        setVoices(Array.isArray(data?.voices) ? data.voices : []);
      } catch (e: any) {
        if (e?.name !== "AbortError") {
          console.error("[voices] error", e);

          setError(e instanceof Error ? e.message : String(e));
        }
      } finally {
        setLoading(false);
      }
    })();

    return () => ctrl.abort();
  }, [API_BASE]);

  return { voices, loading, error };
}
