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
  const host: string = process.env.API_SERVER_HOST ?? "localhost";
  const port: string = process.env.API_SERVER_PORT ?? "1323";
  console.log("process.env.API_SERVER_HOST", process.env.API_SERVER_HOST);

  const res = await fetch(`http://${host}:${port}/api/companies`, {
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
