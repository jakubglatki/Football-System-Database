
//2. Print a list of all the accommodations sorted first by price,
// and then by the number of amenities they offer.
db.getCollection("lodging").aggregate(
  {$unwind: "$lodging"},
  {$sort: {"lodging.price": 1, "lodging.amenities": 1}}
);


//5. Print all the combinations of points that were assigned to the 
// accommodations and sort them by the number of accommodations that received these points.

db.getCollection("lodging").aggregate(
 {$unwind: "$lodging.reviews"},
  {$group:{
     _id : "$_id",
     //{$add: ['$lodging.reviews.cleanliness', '$lodging.reviews.location', '$lodging.reviews.food']}
     cleanliness: {$push: "$lodging.reviews.cleanliness"},
     location: {$push: "$lodging.reviews.location"},
     food: {$push: "$lodging.reviews.food"}
     }
     },
  
   {$sort: {cleanliness:-1}}
);
