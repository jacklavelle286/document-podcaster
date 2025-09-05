import { useEffect, useState } from "react";

export default function HelloOnMount() {
  const API_BASE = import.meta.env.VITE_API_BASE_URL;
  const [data, setData] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const ctrl = new AbortController();

    (async () => {
        try {
            const res = await fetch(`${API_BASE}/test`, {signal: ctrl.signal});
            if (!res.ok) throw new Error(`HTTP ${res.status}`);
            const bodyText = await res.text();
            setData(bodyText);
        } catch ( err: any) {
            if (err?.name === "AbortError") return;
            setError(err instanceof Error ? err.message : String(err));
        }
    })();

    return () => ctrl.abort();
  }, [API_BASE]);

  if (error) return <p className="text-danger"> Error: {error} </p>
  if (!data) return <p>Loading..</p>
  return <p>Response: {data}</p>
}
