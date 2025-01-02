"use client";

import React, { useState } from "react";
import Image from "next/image";
import Button from "@mui/material/Button";

export function ClientComponent() {
  const [count, setCount] = useState(0);
  return <Button onClick={() => setCount(count + 1)}>Count: {count}</Button>;
}

export interface ImageProps {
  srcUrl: string;
  alt: string;
}

export const ImageComponent = (props: ImageProps): React.JSX.Element => {
  return (
    <Image src={props.srcUrl} alt={props.alt} width={200} height={250}></Image>
  );
};
