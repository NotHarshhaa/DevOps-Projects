import React from "react";

export default function createSafeContext<TValue extends {} | null>() {
  const context = React.createContext<TValue | undefined>(undefined);

  function useContext() {
    const value = React.useContext(context);
    if (value === undefined) {
      throw new Error("useContext must be inside a Provider with a value");
    }
    return value;
  }

  return [useContext, context.Provider] as const;
}
