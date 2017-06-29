create view VW_TOTAL_PAYMENTS as
select claim_id, sum(payment_amount) as TOTAL_PAYMENTS
from claim_payment
group by claim_id