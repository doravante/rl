package br.ufrj.ppgi.rl.performance;

import java.util.Random;

import org.apache.commons.lang3.time.StopWatch;
import org.ejml.simple.SimpleMatrix;

import br.ufrj.ppgi.rl.fa.LLR;

public class LLRPerformanceTest
{
  private static final int TOTAL_RUN   = 20;
  private static final int TOTAL_ADD   = 20000;
  private static final int TOTAL_QUERY = 500000;

  public static void main(String[] args)
  {
    int size = 2000;
    int inputDimension = 2;
    int outputDimension = 1;
    int neighbors = 15;
    double initialValue = -1000;

    long addTime = 0;
    long queryTime = 0;

    Random rand = new Random();
    LLR llr = new LLR(size, inputDimension, outputDimension, neighbors, initialValue, neighbors);

    StopWatch watch = new StopWatch();

    for (int r = 0; r < TOTAL_RUN; r++)
    {
      watch.reset();
      watch.start();
      for (int i = 0; i < TOTAL_ADD; i++)
      {
        llr.add(SimpleMatrix.random(inputDimension, 1, 0, 1, rand), SimpleMatrix.random(outputDimension, 1, 0, 1, rand));
      }
      watch.stop();
      addTime += watch.getTime();
    }

    System.out.println("Add: " + addTime / (double) TOTAL_RUN + " milliseconds.");

    for (int r = 0; r < TOTAL_RUN; r++)
    {
      watch.reset();
      watch.start();
      for (int i = 0; i < TOTAL_QUERY; i++)
      {
        llr.query(SimpleMatrix.random(inputDimension, 1, 0, 1, rand));
      }
      watch.stop();
      queryTime += watch.getTime();
    }
    System.out.println("Query: " + queryTime / (double) TOTAL_RUN + " milliseconds.");
  }

}
