import std.stdio;
import Vertex;

/**
 * Author: Harry Allen
 * Date: September 20, 2014
 * 
 * Class representing edges between vertices.
 */
public class Edge
{
    private double weight;              ///Edge's weight
    private Vertex source, destination; ///Edge's source and destination, respectively

    /**
     * Default constructor.
     */
    public this()
    {
        weight = 0;
        source = null;
        destination = null;
    }

    /**
     * Constructor that initializes the edge's weight to the given accepted int.
     *
     * Params: weight = the new edge's weight
     */
    public this(int weight)
    {
        this.weight = weight;
        source = null;
        destination = null;
    }

    /**
     * Returns: The edge's weight.
     */
    public double getWeight()
    {
        return weight;
    }

    /**
     * Returns: The edge's source.
     */
    public Vertex getSource()
    {
        return source;
    }

    /**
     * Returns: The edge's destination.
     */
    public Vertex getDestination()
    {
        return destination;
    }

    /**
     * Compares this edge's weight to that of the accepted edge.
     *
     * Params: E = the edge to compare with
     *
     * Returns: Returns an int containing -1 if this edge is less than E,
     *  1 if this edge is greater than E, and 0 if the edges are equal
     */
    public int compareTo(Edge E)
    {
        if(this.weight < E.getWeight())
        {
            return -1;
        }

        else if(this.weight > E.getWeight())
        {
            return 1;
        }

        else
        {
            return 0;
        }
    }

    /**
     * Sets the weight to the accepted double.
     *
     * Params: weight = the new weight for this edge
     */
    public void setWeight(double weight)
    {
        this.weight = weight;
    }

    /**
     * Sets the source to the accepted Vertex.
     *
     * Params: source = the new source for this edge
     */
    public void setSource(Vertex source)
    {
        this.source = source;
    }

    /**
     * Sets the destination to the accepted Vertex.
     *
     * Params: destination = the new destination for this edge
     */
    public void setDestination(Vertex destination)
    {
        this.destination = destination;
    }
}