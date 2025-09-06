import { useEffect, useState } from "react";

type VoicesResponse = { voices: string[] };

export default function useVoices() {
  const API_BASE = import.meta.env.VITE_API_BASE_URL as string;

  const [voices, setVoices] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const ctrl = new AbortController();

    (async () => {
      try {
        setLoading(true);
        const res = await fetch(`${API_BASE}/get-voices`, {
          method: "GET",
          signal: ctrl.signal,
        });
        if (!res.ok) throw new Error(`HTTP ${res.status}: ${res.statusText}`);

        const data: VoicesResponse = await res.json();
        setVoices(data.voices);
      } catch (e: any) {
        if (e?.name !== "AbortError") {
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
