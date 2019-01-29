# frozen_string_literal: true

class ForumQuestionsController < ApplicationController
  def index
    set_biz_sub if current_business
    @forum_question = ForumQuestion.new
  end

  # rubocop:disable Metrics/AbcSize
  def show
    cb = current_business
    @question = ForumQuestion.find_by(url: params[:url])
    keys = @question.keywords
    @related_questions = ForumQuestion.where((['body LIKE ?'] * keys.size).join(' OR '), *keys.map { |key| "%#{key}%" })
    @forum_answers = @question.forum_answers.direct
    if cb
      if (cb.subscription?.zero? && cb.qna_views_left.positive?) || ([1, 2].include? cb.subscription?)
        remove_views = cb.qna_viewed_questions.include?(@question.id) ? 0 : 1
        viewed_quesions = cb.qna_viewed_questions.push(@question.id).uniq
        cb.update(qna_views_left: cb.qna_views_left - remove_views, qna_viewed_questions: viewed_quesions)
      else
        @forum_answers.map(&proc { |a| a.body = 'Please subscribe to view this content' })
        @please_subscribe = true
      end
    else
      unless current_user
        @forum_answers.map(&proc { |a| a.body = 'Please sign up to view this content' })
        @please_sign_up = true
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  def new; end

  def create
    @forum_question = ForumQuestion.new(forum_question_params)
    if @forum_question.save
      @forum_question.generate_url
      receivers = Specialist.joins(:industries).where(industries: { id: @forum_question.industries.collect(&:id) }).uniq
      receivers.each do |specialist|
        Notification::Deliver.industry_forum_question!(@forum_question, specialist)
      end
      redirect_to forum_question_path(@forum_question.url)
    else
      render :index
    end
  end

  def search
    @query = params[:search][:query]
    @count = 0
    @questions = []
    @questions = ForumQuestion.where('lower(title) LIKE ?', "%#{@query}%").or(ForumQuestion.where('lower(body) LIKE ?', "%#{@query}%"))
    @count += @questions.count if @questions.present?
    answers = ForumAnswer.where('lower(body) LIKE ?', "%#{@query}%")
    @questions |= ForumQuestion.where(id: answers.collect(&:forum_question_id)) if answers.count.positive?
  end

  private

  def forum_question_params
    params.require(:forum_question).permit(:title, :body, :state, jurisdiction_ids: [], industry_ids: [])
  end

  def set_biz_sub
    @business = current_business
    @forum_sub = current_business.forum_subscription
    @forum_sub = OpenStruct.new(billing_type: 'annual') if @forum_sub.nil?
  end
end
