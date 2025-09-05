interface ButtonProps {
    buttonText: string;
    buttonTextColour?: "white" | "dark";
    buttonColour:
        | "primary"
        | "secondary"
        | "tertiary"
        | "danger"
        | "warning"
        | "success"
        | "close";
    buttonMargin?: string;
    buttonSolid?: boolean;
    buttonType?: "submit" | "button" | "reset";
    dataBSToggle?: string;
    dataBSTarget?: string;
    dataBSDismiss?: string;
    onClick?: React.MouseEventHandler<HTMLButtonElement>;
  
}

export default function Button({
  buttonText,
  buttonTextColour,
  buttonColour,
  buttonMargin = "mx-3",
  buttonSolid = true,
  buttonType = "button",
  dataBSToggle,
  dataBSTarget,
  dataBSDismiss,
  onClick
}: ButtonProps) {
  const buttonColourPrefix = buttonSolid
    ? `text-${buttonTextColour} btn btn-`
    : `text-${buttonTextColour} btn btn-outline-`;
  return (
    <button
      type={buttonType}
      className={`${buttonColourPrefix}${buttonColour} ${buttonMargin}`}
      data-bs-toggle={dataBSToggle}
      data-bs-target={dataBSTarget}
      data-bs-dismiss={dataBSDismiss}
    >
      {buttonText}
    </button>
  );
}
