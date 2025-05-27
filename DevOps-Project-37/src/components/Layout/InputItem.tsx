import { FormControl, FormErrorMessage, Input } from "@chakra-ui/react";
import React from "react";

type InputItemProps = {
  name: string;
  value?: string;
  placeholder?: string;
  type: string;
  onChange?: (event: React.ChangeEvent<HTMLInputElement>) => void;
  mb?: number;
  bg?: string;
  size?: string;
};

const InputItem: React.FC<InputItemProps> = ({
  name,
  placeholder,
  value,
  type,
  onChange,
  mb,
  bg,
  size,
}) => {
  return (
    <Input
      name={name}
      placeholder={placeholder}
      value={value}
      required
      onChange={onChange}
      mb={mb}
      fontSize="10pt"
      _placeholder={{ color: "gray.500" }}
      _hover={{
        bg: "white",
        border: "1px solid",
        borderColor: "blue.500",
      }}
      _focus={{
        outline: "none",
        bg: "white",
        border: "1px solid",
        borderColor: "blue.500",
      }}
      bg={bg || "gray.50"}
      size={size}
      type={type}
      borderRadius={4}
    />
  );
};
export default InputItem;
