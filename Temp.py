public class SecondLargest {
    public static void main(String[] args) {
        int[] numbers = {10, 25, 8, 45, 30, 45};

        int first = Integer.MIN_VALUE;
        int second = Integer.MIN_VALUE;

        for (int num : numbers) {
            if (num > first) {
                second = first;
                first = num;
            } else if (num > second && num < first) {
                second = num;
            }
        }

        if (second == Integer.MIN_VALUE) {
            System.out.println("No second largest number found!");
        } else {
            System.out.println("Second largest number is: " + second);
        }
    }
}
