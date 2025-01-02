// import { DataGrid, GridColDef } from "@mui/x-data-grid";
// import Link from "next/link";
import React from "react";
import { ClientComponent } from "./clientComponent";

export interface Company {
  id: number;
  version: string;
  name: string;
  established_date?: string;
  created_user_id: number;
}

export default async function Companies() {
  const res = await fetch("http://localhost:1323/api/companies", {
    cache: "no-store",
  });
  const companies: Company[] = await res.json();

  return (
    <>
      <div>Hello New world!</div>
      <div>
        <ClientComponent companies={companies}></ClientComponent>
      </div>
    </>
  );
}
