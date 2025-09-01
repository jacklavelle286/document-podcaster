interface CardProps {
  cardTitle?: string;
  cardText?: string;
  cardTextColour? : "white" | "black"
  backgroundColour?: string
  hoverEffect?: boolean
  children?: React.ReactNode
  cardHeight? : string
  cardWidth? : string

}

export default function Card({
  cardTitle,
  cardText,
  backgroundColour,
  cardTextColour,
  hoverEffect = true,
  children,
  cardHeight = "250",
  cardWidth = "250"
  
}: CardProps) {
  return (
    <>
    <div className="col p-4">
    <div
      className="card bg-image d-flex align-items-center justify-content-center text-center p-1"
      style={{
        transition: hoverEffect ? 'transform 0.3s ease-in-out' : undefined,
        height: `${cardHeight}`,
        width: `${cardWidth}`,
        backgroundColor: backgroundColour,
        color: cardTextColour
      }}
      onMouseEnter={hoverEffect ? (e) => {
        e.currentTarget.style.transform = 'translateY(-5px)';
      } : undefined}
      onMouseLeave={hoverEffect ? (e) => {
        e.currentTarget.style.transform = 'translateY(0)';
      } : undefined}
    >
      <div className="card-body d-flex flex-column align-items-center justify-content-center w-100 h-100">
        <h5 className="card-title">{cardTitle}</h5>
        <p className="card-text">{cardText} </p>
        {children}
      </div>
    </div>
    </div>
    </>
  );
}


