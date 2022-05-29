-- The product that was sold in the greatest quantity during a stage
SELECT
    name,
    quantity
FROM
    Sell_Product NATURAL
    JOIN produit
WHERE
    quantity = (
        SELECT
            MAX(quantity)
        FROM
            Sell_Product
    );
