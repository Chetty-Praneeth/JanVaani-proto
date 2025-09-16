import React, { useState } from 'react';

const ReviewPage = () => {
  const [reviews] = useState([]); // only use reviews, not setReviews

  return (
    <div>
      <h1>Feedbacks</h1>
      {reviews.length === 0 ? (
        <p>User feedbacks appear here </p>
      ) : (
        <ul>
          {reviews.map((review, index) => (
            <li key={index}>{review.title}</li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default ReviewPage;
