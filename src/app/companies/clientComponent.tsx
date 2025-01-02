"use client";

import { DataGrid, GridColDef } from "@mui/x-data-grid";
import React from "react";
import { Company } from "./page";
import Link from "next/link";

interface companyProps {
  companies: Company[];
}

export function ClientComponent(props: companyProps) {
  const companyColumns: GridColDef[] = [
    {
      field: "page",
      headerName: "ページ遷移",
      renderCell: (params) => {
        return <Link href={`/companies/${params.id}`}>移動</Link>;
      },
    },
    {
      field: "id",
      headerName: "id",
      width: 150,
    },
    { field: "version", headerName: "version", width: 150 },
    { field: "name", headerName: "name", width: 150 },
    { field: "established_date", headerName: "established_date", width: 150 },
    { field: "created_user_id", headerName: "created_user_id", width: 150 },
  ];
  return (
    <>
      <div>Hello New world!</div>
      <div>
        <DataGrid rows={props.companies} columns={companyColumns} />
      </div>
    </>
  );
}
