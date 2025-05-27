import type { ComponentStyleConfig } from "@chakra-ui/theme";

export const Input: ComponentStyleConfig = {
  baseStyle: {
    field: {
      fontSize: "10pt",
      bg: "gray.50",
      _placeholder: {
        color: "gray.500",
      },
      _hover: {
        bg: "white",
        border: "1px solid",
        borderColor: "blue.500",
      },
      _focus: {
        outline: "none",
        border: "1px solid",
        borderColor: "blue.500",
      },
    },
    addons: {
      height: "30px",
    },
  },
  sizes: {
    md: {
      field: {
        // height: "30px",
        fontSize: "10pt",
      },
    },
  },
  variants: {},
  defaultProps: {
    variant: null,
  },
};
