interface CardProps {
  cardTitle: string;
  cardText: string;
  backgroundColour: string
  children?: React.ReactNode
}

export default function Card({
  cardTitle,
  cardText,
  backgroundColour,
  children
  
}: CardProps) {
  return (
    <>
    <div className="col p-4">
    <div className="card bg-image" style={{ 
      transition: 'transform 0.3s ease-in-out',
      height: '250px',
      backgroundColor: backgroundColour,
      
    }}
    onMouseEnter={(e) => {
      e.currentTarget.style.transform = 'translateY(-5px)';
    }}
    onMouseLeave={(e) => {
      e.currentTarget.style.transform = 'translateY(0)';
    }}>
      <div className="card-body">
      <h5 className="card-title">{cardTitle}</h5>
      <p className="card-text">{cardText} </p>
      {children}
      </div>
    </div>
    </div>
    </>
  );
}


