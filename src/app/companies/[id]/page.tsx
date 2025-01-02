import { Company } from "../page";
import { ClientComponent, ImageComponent } from "./clientComponent";
import Button from "@mui/material/Button";

export default async function CompanyById({
  params,
}: {
  params: { id: string };
}) {
  const { id } = await params;
  const res = await fetch(`http://localhost:1323/api/companies/${id}`, {
    cache: "no-store",
  });
  const company: Company = await res.json();
  return (
    <>
      <div>
        <Button>テスト</Button>
        <p>company.id:{company.id}</p>
        <p>company.name:{company.name}</p>
        <ImageComponent
          srcUrl={`https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png`}
          alt={"altImage"}
        ></ImageComponent>
        <p>company.createdUserId:{company.created_user_id}</p>
        <p>company.establishedDate:{company.established_date}</p>
        <ClientComponent></ClientComponent>
      </div>
    </>
  );
}
