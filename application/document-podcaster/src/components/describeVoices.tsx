import { useEffect, useState, useCallback } from "react";


type VoicesResponse = { voices: string[] }

export default function useVoices() {
  const API_BASE = import.meta.env.VITE_API_BASE_URL as string;

  const [ voices, setVoices] = useState<string[]>([]);
  const [ loading, setLoading ] = useState(false);
  const [ error, setError ] = useState<string | null>(null)  
  useEffect(() => {
    const ctrl = new AbortController();
    (async () => {
        setLoading(true);
        const res = await fetch(`${API_BASE}/get-voices`, {method: "GET", signal: ctrl.signal});
        if (!res.ok) throw new Error(`HTTP ${res.status}: ${res.statusText}`)
        const data: VoicesResponse = await res.json();
    })

  }

)
}   