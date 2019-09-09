class Api::V1::Tasks::Operation::Update < Trailblazer::Operation
  step :find_model
  step :mark_as_done!
  step Api::V1::Tasks::Lib::RendererOptions

  def find_model(ctx, params:, **)
    ctx['task'] = Task.find_by(id: params[:id])
  end

  def mark_as_done!(_ctx, task:, **)
    task.update(done: true)
  end
end
