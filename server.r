options(scipen = 999)
source('global.R')

shinyServer(function(input, output, clientData, session) {
	
	model = data.table(read.csv('data/scorecard.csv', header=TRUE, sep=","), key = c('attribute','value'))
	
	binarization = function(data) {
		
		data = copy(data)
		data[ , `:=`(
				loanAmount = as.factor(ifelse(as.numeric(loanAmount) <= 4500, '0-4500', ifelse(as.numeric(loanAmount) <= 9000, '4500-9000', ifelse(as.numeric(loanAmount) <= 21000, '9000-21000', ifelse(as.numeric(loanAmount) <= 35000, '21000-35000', '35000+')))))
				,property = as.factor(property)
				,creditDuration = as.factor(ifelse(as.numeric(creditDuration) <= 12, '0-12', ifelse(as.numeric(creditDuration) <= 36, '12-36', '36+')))
				,age = as.factor(age)
				,dependants = as.factor(ifelse(as.numeric(dependants) < 1, "0",ifelse(as.numeric(dependants) < 3, "1-2", ifelse(as.numeric(dependants) < 4, "3", "4+"))))
				,monthObligations = ifelse(as.numeric(monthObligations) < 700, "<700", ifelse(as.numeric(monthObligations) < 1000, "700-1000", ifelse(as.numeric(monthObligations) < 200, "1000-2000", "2000+")))
				,obligationsToIncome = ifelse(as.numeric(obligationsToIncome) < 0.28, "<0.28", ifelse(as.numeric(obligationsToIncome) < 0.33, "0.28-0.33", ifelse(as.numeric(obligationsToIncome) < 0.38, "0.33-0.38", ifelse(as.numeric(obligationsToIncome) < 0.43, "0.38-0.43", ifelse(as.numeric(obligationsToIncome) < 0.55, "0.43-0.55", "0.55+")))))
				,loanToValue = as.factor(ifelse(as.numeric(loanToValue) <= 0.5, '<0.5', ifelse(as.numeric(loanToValue) <= 0.77, '0.5-0.77', '0.77+')))
				,dealerID = as.factor(ifelse(as.numeric(dealerID) %in% c(1,3,4,7),"1,3,4,7",ifelse(as.numeric(dealerID) %in% c(6,2),"6,2",ifelse(as.numeric(dealerID) == 8,"8","5"))))
			)]
		data_bin = data.table(attribute = colnames(data), value = t(data)[,1])
		
		return(data_bin)
	}
	
	score_calc = function(data_bin, model) {
		data_bin = copy(data_bin)
		setkeyv(data_bin, c('attribute','value'))
		model = copy(model)
		data_bin[model, score := i.score]
		
		res = list()
		res$score = sum(data_bin[,score],na.rm = T) + 150
		res$odds = round(score_2_odds(res$score),6)
		res$pd = round(odds_2_pd(res$odds),6)
		res$decision = pd_2_decision(res$pd)
		#	"May the force be with you!"
		return(res)
	}
	
	score_2_odds = function(score, score_def = 500, odds_def = 20, points_to_double = 20) {
		odds = odds_def *  2 ^ ((score - score_def) / points_to_double)
		return(odds)
	}
	odds_2_pd = function(odds) {
		pd = 1 / (1 + odds)
		return(pd)
	}
	pd_2_decision = function(pd, dots = c(0.01,0.03,0.065,0.09,0.2)) {
		if (pd <= dots[1])	{return("Risk group A;\nAutomatic approve;\nInterest Rate = 2.8 %\nSpecial offer and \nloyality program recommended")}
		else if (pd > dots[1] & pd <= dots[2])	{return("Risk group B;\nAutomatic approve;\nInterest Rate = 3.5 %\nLoyality program recommended")}
		else if (pd > dots[2] & pd <= dots[3])	{return("Risk group C;\nAutomatic approve;\nInterest Rate = 5 %\nCredit risk is acceptable")}
		else if (pd > dots[3] & pd <= dots[4])	{return("Risk group D;\nApprove recommended;\nCredit committee review required;\nInterest Rate = 7 %")}
		else if (pd > dots[4] & pd <= dots[5])	{return("Risk group E;\nDecline recommended;\nCredit committee review required;\nInterest Rate = 9 %")}
		else if (pd > dots[5])	{return("Risk group F;\nAutomatic decline;\nCredit risk significantly\nexceeds acceptable level")}
	}
	
	dataInput <- reactive({
	
		data = data.table(
					creditDuration = as.numeric(input$creditDuration)
					,loanAmount = as.numeric(input$loanAmount)
					,property = as.factor(input$property)
					,age = as.factor(input$age)
					,dependants = as.numeric(input$dependants)
					,monthObligations = as.numeric(input$monthObligations)
					,obligationsToIncome = as.numeric(input$obligationsToIncome) / 100
					,loanToValue = as.numeric(input$loanToValue) / 100
					,dealerID = as.numeric(input$dealerID)			
				)
			
		#credit_quality = ifelse(modelPredict(m$fit, data), "Good", "Bad")
		data = binarization(data)
				
		try(score_calc(data,model),silent = T)
	})
	
	output$score <- renderText({
	
			return(dataInput()$score)
		
	
	})
	output$odds <- renderText({
	
			return(dataInput()$odds)
		
	
	})
	output$pd <- renderText({
	
			return(dataInput()$pd)
		
	
	})
	output$decision <- renderText({
	
			return(dataInput()$decision)
		
	
	})
	
	output$scorecard <- renderDataTable({
		
		res = data.table(model)
		res

	}, options = list(pageLength = 20))

	session$onSessionEnded(function() {
		stopApp()
	})
})
