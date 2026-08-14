import { Check, ChevronsUpDown } from "lucide-react";
import type React from "react";
import { useState } from "react";
import { Command, CommandEmpty, CommandGroup, CommandInput, CommandItem, CommandList } from "@/components/ui/command";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { ScrollArea } from "@/components/ui/scroll-area";
import { countries } from "@/data/countries";
import { cn } from "@/lib/utils";

interface CountryPickerProps {
  value: string;
  onChange: (value: string) => void;
  hasError?: boolean;
}

export const CountryPicker: React.FC<CountryPickerProps> = ({ value, onChange, hasError }) => {
  const [open, setOpen] = useState(false);
  const selected = countries.find((c) => c.value === value);

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <button
          type="button"
          role="combobox"
          aria-expanded={open}
          className={cn(
            "flex w-full items-center justify-between rounded-xl border bg-card py-3 pl-10 pr-4 text-sm text-foreground outline-none transition-all focus:ring-2 focus:ring-primary/30",
            hasError ? "border-destructive ring-2 ring-destructive/20" : "border-border"
          )}
        >
          <span className={selected ? "text-foreground" : "text-muted-foreground/50"}>
            {selected ? `${selected.flag} ${selected.label}` : "Select your country"}
          </span>
          <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 text-muted-foreground" />
        </button>
      </PopoverTrigger>
      <PopoverContent className="w-[--radix-popover-trigger-width] p-0" align="start">
        <Command>
          <CommandInput placeholder="Search countries..." />
          <CommandList>
            <CommandEmpty>No country found.</CommandEmpty>
            <CommandGroup>
              <ScrollArea className="h-60">
                {countries.map((country) => (
                  <CommandItem
                    key={country.value}
                    value={country.label}
                    onSelect={() => {
                      onChange(country.value);
                      setOpen(false);
                    }}
                  >
                    <Check className={cn("mr-2 h-4 w-4", value === country.value ? "opacity-100" : "opacity-0")} />
                    <span className="mr-2">{country.flag}</span>
                    {country.label}
                  </CommandItem>
                ))}
              </ScrollArea>
            </CommandGroup>
          </CommandList>
        </Command>
      </PopoverContent>
    </Popover>
  );
};
