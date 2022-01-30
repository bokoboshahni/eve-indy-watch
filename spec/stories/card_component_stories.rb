# frozen_string_literal: true

class CardComponentStories < ApplicationStories
  story :basic do
    body.content(text(Faker::Lorem.paragraph).name('Body'))
  end

  story :title do
    constructor(title: text(Faker::Lorem.sentence.titleize).name('Title'))

    body.content(text(Faker::Lorem.paragraph).name('Body'))
  end

  story :title_and_description do
    constructor(title: text(Faker::Lorem.sentence.titleize).name('Title'))

    description { Faker::Lorem.sentence }

    body.content(text(Faker::Lorem.paragraph).name('Body'))
  end

  story :ball do
    ball_color = select(%w[bg-blue-500 bg-green-500 bg-red-500 bg-yellow-500], 'bg-blue-500')
    constructor(title: text(Faker::Lorem.sentence.titleize).name('Title'), ball: true, ball_color: ball_color)

    body.content(text(Faker::Lorem.paragraph).name('Body'))
  end

  story :footer do
    footer_bg = select(%w[bg-white bg-gray-50], 'bg-gray-50')
    constructor(title: text(Faker::Lorem.sentence.titleize).name('Title'), footer_bg: footer_bg)

    body do
      content_tag :p, text(Faker::Lorem.paragraph).name('Body')
    end
    body.content(text(Faker::Lorem.paragraph).name('Body'))

    footer.content(text(Faker::Lorem.paragraph).name('Footer'))
  end
end
