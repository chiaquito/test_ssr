import { DataGrid, GridColDef } from "@mui/x-data-grid";
import React from "react";

export interface Product {
  id: number;
  title: string;
  price: number;
  category: string;
  description: string;
  image: string;
  rating: {
    rate: number;
    count: number;
  };
}

export default async function Products() {
  const res = await fetch("https://fakestoreapi.com/products", {
    cache: "no-store",
  });
  const products: Product[] = await res.json();

  const productColumns: GridColDef[] = [
    { field: "id", headerName: "id", width: 150 },
    { field: "title", headerName: "title", width: 150 },
    { field: "price", headerName: "price", width: 150 },
    { field: "category", headerName: "category", width: 150 },
  ];

  return (
    <>
      <div>Hello New world!</div>
      <div>
        <DataGrid rows={products} columns={productColumns} />
      </div>
    </>
  );
}
