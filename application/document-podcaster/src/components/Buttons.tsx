interface ButtonProps {
  buttonText: string;
  buttonColour: "primary" | "secondary" | "tertiary" | "danger" | "warning" | "success"
  buttonMargin?: string;
  buttonSolid?: boolean;
  buttonType?: "submit" | "button" | "reset"
}

export default function Button({
  buttonText,
  buttonColour,
  buttonMargin = "mx-3",
  buttonSolid = true,
  buttonType = "button"
}: ButtonProps) {
  const buttonColourPrefix = buttonSolid ? "btn btn-" : "btn btn-outline-";
  return (
    <button
      type={buttonType}
      className={`${buttonColourPrefix}${buttonColour} ${buttonMargin}`}
    >
      {buttonText}
    </button>
  );
}
