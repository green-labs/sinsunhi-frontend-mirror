import { defineCustomElements } from "@duetds/date-picker/dist/loader";
import React, { useEffect, useRef } from "react";

// Register Duet Date Picker
if (typeof window !== "undefined") defineCustomElements(window);

function useListener(ref, eventName, handler) {
  useEffect(() => {
    const current = ref.current;
    if (current) {
      current.addEventListener(eventName, handler);
      return () => current.removeEventListener(eventName, handler);
    }
  }, [eventName, handler, ref]);
}

export function DatePicker({
  identifier,
  onChange,
  onFocus,
  onBlur,
  dateAdapter,
  localization,
  firstDayOfWeek,
  isDateDisabled = () => {},
  ...props
}) {
  const ref = useRef(null);

  useListener(ref, "duetChange", onChange);
  useListener(ref, "duetFocus", onFocus);
  useListener(ref, "duetBlur", onBlur);

  useEffect(() => {
    ref.current.localization = localization;
    ref.current.dateAdapter = dateAdapter;
    ref.current.isDateDisabled = isDateDisabled;
  }, [localization, dateAdapter, isDateDisabled]);

  return (
    <duet-date-picker
      identifier={identifier}
      ref={ref}
      first-day-of-week={firstDayOfWeek}
      {...props}
    />
  );
}
