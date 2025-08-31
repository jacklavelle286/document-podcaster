interface CardProps {
  cardTitle: string;
  cardText: string;
  cardImagePath: string;
}

export default function Card({
  cardTitle,
  cardText,
  cardImagePath,
}: CardProps) {
  return (
    <>
    <div className="col p-4">
      <div className="card bg-image" style={{ 
        transition: 'transform 0.3s ease-in-out'
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.transform = 'translateY(-5px)';
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.transform = 'translateY(0)';
      }}>
        <img src={cardImagePath} className="card-img-top" alt="..." />
        <div className="card-body">
        <h5 className="card-title">{cardTitle}</h5>
        <p className="card-text">{cardText} </p>
        </div>
      </div>
    </div>
    </>
  );
}
