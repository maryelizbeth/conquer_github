class ConquerGithub 
  def call(env)
    [200, {}, "Hello World"]
  end 
end 

run ConquerGithub.new