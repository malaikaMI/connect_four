require 'spec_helper'
require 'connect_four'
module ConnectFour
  describe Board do
    let(:board) {Board.new}

    describe "#initialize" do
      it "generate full grids hash with coordinates as key and ' ' as value" do
        expect(board.grids.size).to eql(42)
        expect(board.grids[[5,5]]).to eql(' ')
      end
    end


  end

  describe Players do

    describe "#initialize" do
      let(:player1) {Players.new('Y','name')}

      it "initialize a player with a color and a name" do

        expect(player1.color).to eql('Y')
        expect(player1.name).to eql('name')
      end
    end
  end

  describe Game do
    let(:john) {Players.new('Y','John')}
    let(:snow) {Players.new('R','Snow')}
    let(:game) {Game.new([snow, john])}

    describe "#initialize" do
      it "ramdomly select a player as current player" do
        allow_any_instance_of(Array).to receive(:shuffle).and_return([john, snow])
        expect(game.current_player).to eq(john)
      end
      it "randomly select the other player as the other player" do
        allow_any_instance_of(Array).to receive(:shuffle).and_return([john, snow])
        expect(game.other_player).to eq(snow)
      end
    end

    describe "#switch_players" do
      let(:game) {Game.new([john, snow])}
      it "will set @current_player to @other_player" do
        other_player = game.other_player
        game.switch_players
        expect(game.current_player).to eq(other_player)
      end

      it "will set @other_player to @current_player" do
        current_player = game.current_player
        game.switch_players
        expect(game.other_player).to eq(current_player)
      end
    end

    describe "#make_a_move" do
      context "when first the player choose x = 0" do
        it "sets [0,0]'s value = current_player's color" do
          game.make_a_move(0)
          expect(game.board.grids[[0,0]]).to eq(game.current_player.color)
        end
      end

      context "when x = 0, second move" do
        it "set [0,1]'s value = current_player's color" do
          game.make_a_move(0)
          game.switch_players
          game.make_a_move(0)
          expect(game.board.grids[[0,1]]).to eq(game.current_player.color)
        end
      end

      context "when x = 0, third move " do
        it "set[0,2]'s value = current_player's color" do
          game.make_a_move(0)
          game.switch_players
          game.make_a_move(0)
          game.switch_players
          game.make_a_move(0)
          expect(game.board.grids[[0,2]]).to eq(game.current_player.color)
        end
      end

      context "throw a move to x = 0 and x = 1" do
        it "those two grids eql @current_player.color" do
          game.make_a_move(0)
          game.make_a_move(1)
          expect(game.board.grids[[0,0]]).to eql(game.current_player.color)
          expect(game.board.grids[[1,0]]).to eql(game.current_player.color)
        end
      end

    end

    describe "#check_horizonally" do
      context 'y = 0, when four grids in a line horizonally from the same player' do
        it "wins the game and return true" do
          game.make_a_move(0)
          game.make_a_move(1)
          game.make_a_move(2)
          game.make_a_move(3)
          expect(game.check_horizonally).to eql(true)
        end
      end

      context "y = 0, when four girds in a line horizonally but from two players" do
        it "return false" do
          game.make_a_move(0)
          game.make_a_move(1)
          game.switch_players
          game.make_a_move(2)
          game.make_a_move(3)
          expect(game.check_horizonally).to eql(false)
        end
      end

      context "y = 0, when four girds in a line horizonally but not in the first grids" do
        it "returns true" do
          game.make_a_move(0)
          game.make_a_move(1)
          game.switch_players
          game.make_a_move(2)
          game.make_a_move(3)
          game.make_a_move(4)
          game.make_a_move(5)
          expect(game.check_horizonally).to eql(true)
        end
      end

      context "y != 0, when four girds in a line horizonally but not in the first grids " do
        it 'returns true' do
          game.make_a_move(0)
          game.make_a_move(1)
          game.make_a_move(2)
          game.switch_players
          game.make_a_move(3)
          game.make_a_move(4)
          game.make_a_move(5)
          game.make_a_move(0)
          game.make_a_move(1)
          game.make_a_move(2)
          game.make_a_move(3)
          expect(game.check_horizonally).to eql(true)
        end
      end
    end

    describe "#check_vertically" do
      context 'x = 0, when four girds in a line vertically but not in the first grids' do
        it 'returns true' do
          game.make_a_move(0)
          game.switch_players
          4.times {game.make_a_move(0)}
          expect(game.check_vertically).to eql(true)
        end
      end

      context "x = 0, when four grids are seperated into two collumn" do
        it "returns false" do
          game.make_a_move(0)
          game.make_a_move(0)
          game.make_a_move(1)
          game.make_a_move(1)
          expect(game.check_vertically).to eql(false)
        end
      end
    end

    describe "#check_diagonally_ascend" do
      context "start from y = 0, when four grids are in a line like diagonally_ascend" do
        it "returns true" do
          game.make_a_move(0)
          game.switch_players
          game.make_a_move(1)
          game.make_a_move(2)
          game.make_a_move(3)
          game.make_a_move(2)
          game.make_a_move(3)
          game.make_a_move(3)
          game.switch_players
          game.make_a_move(1)
          game.make_a_move(2)
          game.make_a_move(3)
          expect(game.check_diagonally).to eql(true)
        end
      end

      context "when diagonally_ascend four grids are seperated" do
        it "returns false" do
          game.make_a_move(0)
          2.times {game.make_a_move(4)}
          game.switch_players
          game.make_a_move(1)
          3.times {game.make_a_move(2)}
          game.make_a_move(3)
          2.times {game.make_a_move(4)}
          game.switch_players
          game.make_a_move(1)
          3.times {game.make_a_move(3)}
          game.make_a_move(4)
          expect(game.check_diagonally).to eql(false)
        end
      end

      context "not start from y = 0, when four grids are in a line like diagonally_ascend" do
        it "returns true" do
          game.make_a_move(0)
          3.times {game.make_a_move(4)}
          2.times {game.make_a_move(5)}
          game.switch_players
          2.times{game.make_a_move(1)}
          game.make_a_move(2)
          2.times{game.make_a_move(3)}
          game.make_a_move(4)
          2.times {game.make_a_move(5)}
          game.switch_players
          2.times{game.make_a_move(2)}
          2.times{game.make_a_move(3)}
          game.make_a_move(4)
          2.times {game.make_a_move(5)}
          expect(game.check_diagonally).to eql(true)
        end
      end

      context 'descendly, four grids are seperated into two collumn' do
        it "returns false" do
          3.times {game.make_a_move(1)}
          game.make_a_move(5)
          game.switch_players
          2.times{game.make_a_move(2)}
          game.make_a_move(3)
          2.times{game.make_a_move(4)}
          game.make_a_move(1)
          game.switch_players
          game.make_a_move(1)
          2.times{game.make_a_move(2)}
          2.times{game.make_a_move(3)}
          expect(game.check_diagonally).to eql(false)
        end
      end

      context "when four grids are in a line like diagonally_ascend" do
        it "returns true" do
          3.times {game.make_a_move(1)}
          game.make_a_move(5)
          game.switch_players
          2.times{game.make_a_move(2)}
          game.make_a_move(3)
          2.times{game.make_a_move(4)}
          game.make_a_move(1)
          game.switch_players
          game.make_a_move(1)
          2.times{game.make_a_move(2)}
          2.times{game.make_a_move(3)}
          2.times{game.make_a_move(0)}
          game.switch_players
          2.times{game.make_a_move(0)}
          game.switch_players
          2.times{game.make_a_move(0)}
          expect(game.check_diagonally).to eql(true)
        end
      end
    end

    describe "#end?" do
      context " when all the grids are occupied" do
        it "returns true" do
          game.board.grids.each do |key, value|
            game.board.grids[key] = 'x'
          end
          expect(game.end?).to eql(true)
        end
      end

      context "when there is even one grids is ' '" do
        it "returns false" do
          game.board.grids.each do |key, value|
            game.board.grids[key] = 'x'
          end
          game.board.grids[[rand(0..6), rand(0..5)]] = ' '
          expect(game.end?).to eql(false)
        end
      end
    end

    describe "#draw?" do
      context " if the game is end, and no one wins" do
        it "returns true" do
          allow(game).to receive(:win?) {false}
          allow(game).to receive(:end?) {true}
          expect(game.draw?).to eq true
        end
      end

      context "if the game is end, and some one wins" do
        it "returns false" do
          allow(game).to receive(:win?) {true}
          allow(game).to receive(:end?) {true}
          expect(game.draw?).to eq false
        end
      end

      context "if hte game is not end, and some on wins" do
        it "returns false" do
          allow(game).to receive(:win?) {true}
          allow(game).to receive(:end?) {false}
          expect(game.draw?).to eq false
        end
      end
    end

    describe "#win?" do
      context "when check_horizonally return true, others false" do
        it "returns true" do
          allow(game).to receive(:check_horizonally) {true}
          allow(game).to receive(:check_vertically) {false}
          allow(game).to receive(:check_diagonally) {false}
          expect(game.win?).to eq true
        end
      end
    end

    describe "#start" do
      context "when someone wins" do
        it "leave a string including 'Congratulations'" do
          allow(game).to receive(:gets){'rand(0..6)'}
          allow(game).to receive(:win?){true}
          expect(game.start).to include('Congratulations')
        end
      end

      context "when it is draw" do
        it "leaves a string including 'draw'" do
          allow(game).to receive(:gets){'rand(0..6)'}
          allow(game).to receive(:end?){true}
          allow(game).to receive(:draw?){true}
          expect(game.start).to include('draw')
        end
      end
    end

    describe "#ask_player" do
      context "when input 0" do
        it "returns 0" do
          allow(game).to receive(:gets){'0'}
          expect(game.ask_player).to eql(0)
        end
      end

      context "when input 6" do
        it "returns 6" do
          allow(game).to receive(:gets){'3'}
          expect(game.ask_player).to eql(3)
        end
      end

      context "when input 9" do
        it "ask input again until gets correct answer" do
          allow(game).to receive(:gets) do
            @i ||= 0
            input = case @i
            when @i == 0 then '9'
            when @i == 1 then 'a'
            else
              '5'
            end
            @i += 1
            input
          end
          expect(game.ask_player).to eql(5)
        end
      end
    end
  end



end