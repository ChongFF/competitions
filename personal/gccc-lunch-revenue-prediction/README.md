**********************************************************************************
**Calling all Data Scientist / Modeler / Statistician : Can you help better predict weekly revenue?**
**********************************************************************************

**BACKGROUND**: My church has long used long-term average for the week of the month to predict revenue for the week for its Sunday lunch. As a result, the prediction for the first week of January is the same for that of July or of September. This has resulted in some significant mis-prediction in recent periods. We are now looking for a more accurate way to anticipate demand for the lunch and hence avoid over-ordering (waste of food and financial loss) or under-ordering (some people would not be served).

**DATA**: lunch_analytics_train.csv: time series revenue data

  1. 0 means that lunch is not offered that weekend, hence no revenue
  2. . means that lunch is offered that weekend, but the revenue data for that week is not avaialble

**EVALUATION METRIC**: Root-mean Square Error $\sqrt{\frac{1}{n} \Sum^n_{i=1} (y_i - yhat_i)^2}$

**SUBMISSION PROCESS**:

  1. Submit your username (to be displayed on the Public Leaderboard) and revenue prediction for the 7 out of the 9 weekends in August and September: 8/6, 8/13, 8/20, 8/27, 9/3, 9/10, 9/17
  2. Each of the 7 predictions needs to be a non-missing positive number.
  3. You may make up to 5 submissions. You are encouraged to try out different model structure - LSTM, ARIMA, ARIMA with seasonality, ...
  4. Evaluation metric based on the first 3 weekends in August will be provided to you and best among an individuals scores will be published on the public LB.
  5. You may choose two of your submissions to be evaluated for placement on private LB (based on the Evaluation Metric on the remaining 4 weekends' prediction).
    
**TIMELINE**: 9/23/2017 - 9/30/2017 11:59:59PM EST

**REWARD**:

  1. You are only eligible for Reward if you are willing to share your algorithm with me and allow that to be implemented to help my church improves its finance.
  2. I will be forever grateful for your help and will buy the Top Performer (based on Private LB placement) lunch at a restaurant of your choice! (If you are not local, I can mail you a $15 giftcard of your choice =))
  3. You get to put what you've learnt in classroom into practice!
  4. You can live with the satisfying thought that you have made a positive impact!
