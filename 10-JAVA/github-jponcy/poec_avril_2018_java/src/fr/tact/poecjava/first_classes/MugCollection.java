package fr.tact.poecjava.first_classes;

public class MugCollection {

    private Mug[] mugs = new Mug[100];

    private int nb = 0;

    public void addMug(Mug mug) {
        mugs[this.nb] = mug;
        this.nb++;
    }

    private void printSimpleStore(boolean shouldDrawPrice) {
        Mug mug;
        int nameWidth = this.nameMaxLength();
        String line;
        String separator = "+-" + this.repeatChar(nameWidth, '-') + "-+" + (shouldDrawPrice ? "------+" : "") + "-------+--------------------------------+";
        String colTitles = "| " + this.repeatChar(nameWidth - 4, ' ') + "Name | " + (shouldDrawPrice ? "Prix | " : "") + "Stock | Description                    |";

        System.out.println(separator);
        System.out.println(colTitles);
        System.out.println(separator);

        for (int i = 0; i < this.nb; ++i) {
            mug = this.mugs[i];
            line = "| ";

            String spaces = this.repeatChar(nameWidth - mug.getName().length(), ' ');
            line += spaces;

            String description;

            if (mug.getDescription() == null) {
                description = this.repeatChar(30, ' ');
            } else {
                description = String.format("%-30s",
                        mug.getDescription().substring(0, Math.min(30, mug.getDescription().length())));
            }

            line += mug.getName() + " | ";

            if (shouldDrawPrice) line += String.format("%4s", (mug.getPrice() == null ? "" : mug.getPrice())) + " | ";

            line += String.format("%5d", mug.getStock())
                    + " | "
                    + description
                    + " |";

            System.out.println(line);
        }

        System.out.println(separator);
    }

    public void printStore() {
        MugCollection withPrice = new MugCollection();
        MugCollection withoutPrice = new MugCollection();

        for (int i = 0; i < this.nb; ++i) {
            Mug mug = this.mugs[i];

            if (mug.getPrice() == null) {
                withoutPrice.addMug(mug);
            } else {
                withPrice.addMug(mug);
            }
        }

        System.out.println("Availables:");
        withPrice.printSimpleStore(true);
        System.out.println();

        System.out.println("Soon:");
        withoutPrice.printSimpleStore(false);
    }

    private int nameMaxLength() {
        int max = 0;

        for (int i = 0; i < this.nb; ++i) {
            max = Math.max(max, this.mugs[i].getName().length());
        }

        return max;
    }

    private String repeatChar(int spaceNumber, char c) {
        String spaces = "";

        for (int i = 0; i < spaceNumber; ++i) spaces += c;

        return spaces;
    }
}
