import { useState } from "react";
import Button from "./Buttons";

type Status = "idle" | "loading" | "success" | "error";

export default function HelloTester() {
    const API_BASE = import.meta.env.VITE_API_BASE_URL
    const [status, setStatus] = useState<Status>("idle")
    const [data, setData] = useState<string | null>(null)
    const [error, setError] = useState<string | null>(null);

    async function handleClick() {
        setStatus("loading");
        setError(null);
        setData(null);

        try {
            const res = await fetch (`${API_BASE}/test`, {method: "GET"});
            if (!res.ok) throw new Error(`HTTP ${res.status} - ${res.statusText}`);
            const bodyText = await res.text();
            setData(bodyText);
            setStatus("success");
        } catch (err) {
            const msg = err instanceof Error ? err.message : String(err);
            setError(msg);
            setStatus("error")
        }

    }

    return (
        <div>
            <button onClick={handleClick} disabled={status === "loading"}>
                {status === "loading" ? "Loading" : "Call API"}
            </button>
            {status === "success" && <p>Response: {data}</p>}
            {status === "error" && <p className="text-danger">Error: {error}</p>}
        </div>
    )
}