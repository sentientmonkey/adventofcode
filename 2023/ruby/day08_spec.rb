require_relative 'day08'

RSpec.describe Day08 do
  let(:exercise) do
    described_class.new input
  end

  context 'with RL input' do
    let(:input) do
      <<~INPUT
        RL

        AAA = (BBB, CCC)
        BBB = (DDD, EEE)
        CCC = (ZZZ, GGG)
        DDD = (DDD, DDD)
        EEE = (EEE, EEE)
        GGG = (GGG, GGG)
        ZZZ = (ZZZ, ZZZ)
      INPUT
    end

    it 'should get directions' do
      expect(exercise.next_direction).to eq('R')
      expect(exercise.next_direction).to eq('L')
      expect(exercise.next_direction).to eq('R')
      expect(exercise.next_direction).to eq('L')
    end

    it 'should get current node' do
      expect(exercise.current_node).to eq('AAA')
    end

    it 'should get final node' do
      expect(exercise.final_node).to eq('ZZZ')
    end

    it 'should find steps' do
      expect(exercise.find_steps).to eq(2)
    end
  end

  context 'with LLR input' do
    let(:input) do
      <<~INPUT
        LLR

        AAA = (BBB, BBB)
        BBB = (AAA, ZZZ)
        ZZZ = (ZZZ, ZZZ)
      INPUT
    end

    it 'should find steps' do
      expect(exercise.find_steps).to eq(6)
    end
  end
end
