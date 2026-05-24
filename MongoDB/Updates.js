// Autor: Justin Narvaez
// Fecha: 23/05/2026
// Descripción: Práctica de actualización de documentos en sample_airbnb

use("sample_airbnb");

// Cambiar precio de un listing específico
db.listingsAndReviews.updateOne(
  { name: "Rustic Lake House" },
  { $set: { price: NumberDecimal("140.00") } }
);

// Agregar amenity a un listing
db.listingsAndReviews.updateOne(
  { name: "Apartamento Centro Histórico" },
  { $push: { amenities: "Washer" } }
);

// Incrementar reviews de todos los listings en Portugal
db.listingsAndReviews.updateMany(
  { "address.country": "Portugal" },
  { $inc: { number_of_reviews: 1 } }
);

// Quitar "Smoking allowed" de todos los listings
db.listingsAndReviews.updateMany(
  { amenities: "Smoking allowed" },
  { $pull: { amenities: "Smoking allowed" } }
);

// Upsert: actualizar o insertar si no existe
db.listingsAndReviews.updateOne(
  { name: "Villa Privada Justin" },
  {
    $set: {
      property_type: "Villa",
      price: NumberDecimal("800.00"),
      "address.country": "Mexico",
      amenities: ["Pool", "Wifi", "Kitchen", "Free parking"]
    }
  },
  { upsert: true }
);

// Actualizar múltiples campos a la vez
db.listingsAndReviews.updateOne(
  { name: "Cabaña en la Montaña" },
  {
    $set: {
      bedrooms: 1,
      beds: 2,
      summary: "Cabaña acogedora ideal para parejas."
    }
  }
);