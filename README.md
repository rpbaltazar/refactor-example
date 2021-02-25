# Checkout refactoring exercise

## Background

Checkout is one of the most critical parts of our travel platform. It consists of a few steps,
each of them having certain level of complexity. Depending on different parameters we decide
which payment gateway to use, which supplier to make booking with, etc.

This exercise presents a much simplified scenario. Checkout process consists of 5 steps:

1. Check if room is available
1a. If it's not available, stop the process
2. Depending on payment method, process payment (voucher/points/credit card)
2a. If payment fails, choose error message depending on payment and stop the process
3. Depending on supplier, make hotel booking with supplier (booking.com/agoda.com/expedia.com)
3a. If supplier parameter is invalid, stop the process
3b. If booking fails, stop the process
4. Save booking in the database
4a. If saving fails, stop the process
5. Return true

## Task

Your task is to refactor the `call` function in Checkout class. Here are the guidelines:

* Function needs to return `[true, nil]` if the whole process succeeds or `[false, error_message]` if it fails at any step.
* You can add more functions to Checkout class as well as more classes, it's up to you. However, you can't modify existing functions in Checkout class except for `call` function.
* Use spec file provided. It covers all the cases, which means is the tests pass, your code works, if they fail, you made some mistake in refactoring. Do not modify the test file.
* Spec file is quite complex, but it you struggle to understand the code, it can help you.

What matters in the output:

* correctness - from the outside, the checkout function should work in exactly the same way as before; this is ensured by running the tests
* readability - the code should be easy to read, the flow of the checkout process should be easy to understand
* consistency - your Ruby code should be consistent, meaning if in 2 similar cases you use very different way of handling it (e.g. once you return false, once you raise error), it means something can be done better

