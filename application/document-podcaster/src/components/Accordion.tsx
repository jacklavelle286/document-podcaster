interface AccordionTitleProps {
  AccordionTitleName: string;
  AccordionTitleText: string;
  AccordionBody: any;
  AccordionNumber:
    | "one"
    | "two"
    | "three"
    | "four"
    | "five"
    | "six"
    | "seven"
    | "eight"
    | "nine"
    | "ten";
}

export default function AccordionTitle({
  AccordionTitleName,
  AccordionTitleText,
  AccordionBody,
  AccordionNumber,
}: AccordionTitleProps) {
  return (
    <>
      <div className="accordion" id={AccordionTitleName}>
        <div className="accordion-item">
          <h2 className="accordion-header">
            <button
              className="accordion-button"
              type="button"
              data-bs-toggle="collapse"
              data-bs-target={`#collapse${AccordionNumber}`}
              aria-expanded="true"
              aria-controls={`collapse${AccordionNumber}`}
            >
              {AccordionTitleText}
            </button>
          </h2>
          <div
            id={`collapse${AccordionNumber}`}
            className="accordion-collapse collapse show"
            data-bs-parent={`#${AccordionTitleName}`}
          >
            <div className="accordion-body">{AccordionBody}</div>
          </div>
        </div>
      </div>
    </>
  );
}
