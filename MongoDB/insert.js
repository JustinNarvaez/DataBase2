// Autor: Justin Narvaez
// Fecha: 23/05/2026
// Descripción: Práctica de inserción de documentos en sample_airbnb

use("sample_airbnb");

// Insertar un listing básico
db.listingsAndReviews.insertOne({
  name: "Rustic Lake House",
  summary: "A quiet house next to the lake, perfect for relaxing.",
  property_type: "House",
  price: NumberDecimal("120.00"),
  bedrooms: 2,
  beds: 3
});

// Insertar con dirección anidada
db.listingsAndReviews.insertOne({
  name: "Apartamento Centro Histórico",
  summary: "Apartamento moderno en el centro de la ciudad.",
  property_type: "Apartment",
  price: NumberDecimal("95.00"),
  address: {
    country: "Colombia",
    market: "Bogotá",
    street: "Calle 10 # 4-32"
  },
  amenities: ["Wifi", "Kitchen", "Air conditioning"]
});

// Insertar varios a la vez
db.listingsAndReviews.insertMany([
  {
    name: "Tiny House en el Bosque",
    property_type: "Tiny house",
    price: NumberDecimal("60.00"),
    amenities: ["Wifi", "Heating", "Free parking"]
  },
  {
    name: "Penthouse con Vista al Mar",
    property_type: "Apartment",
    price: NumberDecimal("450.00"),
    amenities: ["Wifi", "Pool", "Gym", "Doorman", "Elevator"]
  },
  {
    name: "Cabaña en la Montaña",
    property_type: "Cabin",
    price: NumberDecimal("85.00"),
    amenities: ["Heating", "Free parking", "Kitchen"]
  }
]);